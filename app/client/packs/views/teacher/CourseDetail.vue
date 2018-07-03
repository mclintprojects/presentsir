<template>
    <div class="app-container">
        <el-row>
            <el-col :sm="24" :lg="16">
                <p id="course-name">{{course.name}}</p>
                <p id="course-subdetails">{{course.course_code}} <span :class="{hidden:!course.course_code}">|</span> Identifier: <span>{{course.identifier}}</span></p>
            </el-col>
            <el-col :sm="24" :lg="8" class="flex center-horizontal" id="course-detail-actions">
                <el-button type="success" icon="el-icon-plus" size="small" round>Add a course rep</el-button>
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
						<p>{{enrollment.student_name}}</p>
						<p>Enrolled on: {{getDateString(enrollment.created_at)}}</p>
					</li>
				</ul>
            </el-tab-pane>
            <el-tab-pane label="Course reps" name="course-reps">
                
            </el-tab-pane>
        </el-tabs>
		<el-dialog :visible.sync="showDeleteConfirmation">
			<p>Are you sure you want to delete this course?</p>
			<span slot="footer" class="dialog-footer">
				<el-button @click="showDeleteConfirmation = false" round>Cancel</el-button>
				<el-button type="danger" @click="deleteCourse" :loading="isDeletingCourse" round>Delete</el-button>
			</span>
		</el-dialog>
    </div>
</template>

<script>
import axios from 'axios';
import eventbus from '../../eventbus';

export default {
	data() {
		return {
			course: {},
			activeTab: 'enrollments',
			showDeleteConfirmation: false,
			isDeletingCourse: false,
			enrollments: [],
			isChangingAttendanceState: false
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
			const response = await axios.post(
				`/course/mark_attendance?id=${this.course.id}&state=${state}`
			);

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

#course-enrollments-list {
	li {
		border-bottom: 1px solid rgb(212, 212, 212);
		padding: 16px 0px;

		p:nth-child(1) {
			color: rgba(0, 0, 0, 0.8);
		}

		p:nth-child(2) {
			color: rgba(0, 0, 0, 0.54);
			font-size: 11px;

			span {
				text-transform: uppercase;
			}
		}
	}
}

@media screen and (max-width: 567px) {
	#course-detail-actions {
		margin-top: 16px;
		justify-content: flex-start;
	}
}
</style>
