<template>
    <div class="app-container">
        <el-row>
            <el-col :xs="24" :sm="16" :lg="16">
                <p id="course-name">{{course.name}}</p>
                <p id="course-subdetails">{{course.course_code}} <span :class="{hidden:!course.course_code}">|</span> Identifier: <span>{{course.identifier}}</span></p>
            </el-col>
            <el-col :xs="24" :sm="8" :lg="8" class="flex center-horizontal" id="course-detail-actions">
                <el-button @click="showDeleteConfirmation = true" id="delete-course-btn" type="danger" icon="el-icon-delete" size="small" round>Delete course</el-button>
            </el-col>
        </el-row>
		<div class="flex" style="margin-top: 16px;">
			<el-button :loading="isChangingAttendanceState" :disabled="isChangingAttendanceState" 
			@click="markAttendance(true)" v-if="!course.is_logging_attendance" icon="el-icon-tickets"
			 size="small" round>Start marking attendance</el-button>

			<el-button :loading="isChangingAttendanceState" :disabled="isChangingAttendanceState"
			 @click="markAttendance(false)" v-if="course.is_logging_attendance" type="danger"
			  icon="el-icon-circle-close-outline" size="small" round>End attendance marking</el-button>
		</div>
        <el-tabs style="margin-top: 16px" v-model="activeTab">
            <el-tab-pane label="Enrollments" name="enrollments">
                <p id="course-enrollments-count"><span>{{course.enrollments}}</span> 
				{{course.enrollments === 1 ? 'student' : 'students'}} {{course.enrollments === 1 ? 'has' : 'have'}} enrolled in this course.</p>
				<ul id="course-enrollments-list">
					<li v-for="(enrollment, index) in enrollments" :key="index">
						<p>{{enrollment.student.name}}</p>
						<p>Enrolled on: {{getDateString(enrollment.created_at)}}</p>
					</li>
				</ul>
            </el-tab-pane>
            <el-tab-pane label="Course reps" name="course-reps">
				<el-input v-model="courseRepEmail" placeholder="Enter a course rep's email">
					<el-button slot="append" @click="addCourseRep">Assign</el-button>
				</el-input>
				<div v-if="course.course_reps.length === 0" style="min-height: 60vh;" class="flex center-vertical center-horizontal">
					<empty-state
						src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530649206/present-sir/twotone-supervisor_account-24px.svg"
						title="Course reps" subtitle="You have not assigned any course rep to this course yet." />
				</div>
				<ul id="course-reps-list">
					<li class="flex center-vertical" v-for="(rep, index) in course.course_reps" :key="index">
						<div>
							<p>{{rep.student.name}}</p>
							<p>{{rep.student.email}}</p>
						</div>
						<el-button @click="removeClassRep(rep.id, index)" type="danger" round>Unassign</el-button>
					</li>
				</ul>
            </el-tab-pane>
        </el-tabs>
		<el-dialog :visible.sync="showDeleteConfirmation">
			<p>Are you sure you want to delete this course?</p>
			<span slot="footer">
				<el-button @click="showDeleteConfirmation = false" round>Cancel</el-button>
				<el-button type="danger" @click="deleteCourse" :loading="isDeletingCourse" round>Delete</el-button>
			</span>
		</el-dialog>
    </div>
</template>

<script>
import axios from 'axios';
import EmptyState from '../../components/EmptyState';
import eventbus from '../../eventbus';

export default {
	components: { EmptyState },
	data() {
		return {
			course: { course_reps: [] },
			activeTab: 'enrollments',
			showDeleteConfirmation: false,
			isDeletingCourse: false,
			enrollments: [],
			isChangingAttendanceState: false,
			courseRepEmail: ''
		};
	},
	methods: {
		async deleteCourse() {
			try {
				this.isDeletingCourse = true;
				const response = await axios.delete(`/course?id=${this.course.id}`);

				this.showDeleteConfirmation = false;
				this.$router.go(-1);
				this.isDeletingCourse = false;
			} catch (err) {
				this.$message.error(err.response.data.errors[0]);
				this.isDeletingCourse = false;
			}
		},
		getDateString(date) {
			return eventbus.getDate(date);
		},
		async getEnrollments() {
			const response = await axios.get(
				`/enrollment/course/all?courseId=${this.$route.params.id}`
			);
			this.enrollments = response.data;
		},
		async markAttendance(state) {
			this.isChangingAttendanceState = true;
			const response = await axios.post(`/course/mark_attendance`, {
				id: this.course.id,
				state: state
			});

			if (response.status === 200) {
				this.course.is_logging_attendance = state;
				const message = state
					? 'Students enrolled in this course can now mark themselves as present.'
					: 'Attendance marking session ended.';

				this.$message({
					message,
					type: 'success'
				});
			}
			this.isChangingAttendanceState = false;
		},
		subscribe() {
			const channel = this.$pusher.subscribe('present-sir');
			channel.bind(
				'mark_attendance',
				function(data) {
					if (data.id === this.course.id)
						this.course.is_logging_attendance = data.state;
				}.bind(this)
			);

			channel.bind(
				'course-enroll',
				function(data) {
					if (data.course_id === this.course.id) {
						this.enrollments.push(data.enrollment);
						this.course.enrollments++;
					}
				}.bind(this)
			);

			channel.bind(
				'course-unenroll',
				function(data) {
					if (data.course_id === this.course.id) {
						const index = this.enrollments.findIndex(
							enrollment => enrollment.id === data.enrollment_id
						);

						this.enrollments.splice(index, 1);
						this.course.enrollments--;
					}
				}.bind(this)
			);
		},
		async addCourseRep() {
			try {
				this.isAddingCourseRep = true;
				const response = await axios.post('/course_rep', {
					courseId: this.course.id,
					email: this.courseRepEmail
				});

				this.course.course_reps.push(response.data);
				this.isAddingCourseRep = false;
				this.courseRepEmail = '';
			} catch (err) {
				this.$message.error('Failed to assign as course rep.');
				this.isAddingCourseRep = false;
			}
		},
		async removeClassRep(id, index) {
			const response = await axios.delete(`/course_rep?id=${id}`);
			if (response.status === 200) {
				this.course.course_reps.splice(index, 1);
				this.$message({
					message: 'Successfully unassigned student as course rep.',
					type: 'success'
				});
			}
		}
	},
	async activated() {
		eventbus.$emit('navigatedToChildRoute', 'teacher-courses');

		const id = this.$route.params.id;
		const courses = this.$store.getters.courses;
		if (courses.length > 0)
			this.course = courses.find(course => course.id == id);
		else {
			const response = await axios.get(`/course/search?id=${id}`);
			this.course = response.data;
		}

		this.getEnrollments();
		this.subscribe();
	},
	deactivated() {
		this.$pusher.unsubscribe('present-sir');
		this.course = { course_reps: [] };
		this.activeTab = 'enrollments';
		this.enrollments = [];
	}
};
</script>

<style lang="scss">
$text-color: rgba(0, 0, 0, 0.8);
$text-color-light: rgba(0, 0, 0, 0.54);

#course-name {
	font-size: 18px;
	color: $text-color;
}

#course-subdetails {
	color: $text-color-light;
	margin-top: 8px;
	font-size: 13px;
}

#course-enrollments-count {
	color: $text-color-light;
	font-size: 12px;

	span {
		font-size: 20px;
		color: $text-color;
	}
}

#course-enrollments-list,
#course-reps-list {
	li {
		border-bottom: 1px solid rgb(212, 212, 212);
		padding: 16px 0px;
		justify-content: space-between;

		p:nth-child(1) {
			color: rgba(0, 0, 0, 0.8);
			font-size: 18px;
		}

		p:nth-child(2) {
			color: rgba(0, 0, 0, 0.54);
			font-size: 13px;

			span {
				text-transform: uppercase;
			}
		}
	}
}

#course-detail-actions {
	justify-content: flex-end;
}

@media only screen and (max-width: 567px) {
	#course-detail-actions {
		margin-top: 16px;
		justify-content: flex-start;
	}
}
</style>
