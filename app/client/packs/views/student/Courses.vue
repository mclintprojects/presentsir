<template>
    <div class="app-container">
        <el-tabs v-model="activeTab">
            <el-tab-pane label="Enrollments" name="enrollments">
				<div v-if="enrollments.length === 0" style="min-height: 60vh;" class="flex center-vertical center-horizontal">
					<empty-state
						src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-class-24px.svg"
						title="Enrollments" subtitle="You have not enrolled in any course yet." />
				</div>
				<div class="student-enrollments" v-for="(enrollment, index) in enrollments" :key="index">
					<div>
						<p>{{enrollment.course.teacher_name}}</p>
						<p>{{enrollment.course.name}}<span>|</span>{{enrollment.course.identifier}}</p>
					</div>
					<div><el-button @click="confirmUnenroll(enrollment.id)" type="danger" size="medium" round>Unenroll</el-button></div>
				</div>
				<el-dialog title="Unenroll from course" :visible.sync="isConfirmingUnenroll">
					<p>Are you sure you want to unenroll from this course?</p>
					<span scope="footer" class="dialog-footer">
						<el-button @click="unenrollFromCourse" type="danger" round>Unenroll</el-button>
					</span>
				</el-dialog>
			</el-tab-pane>
            <el-tab-pane label="Enroll" name="enroll">
                <p id="enroll-message">
                    Your teacher should provide their course's identifier with which you can enroll 
                    in their course.
                    Enrolling in a course will allow you to mark yourself as present when that course's 
                    attendance is being logged.
                </p>
                <el-input v-model="enrollQuery" @keyup.enter.native="findCourse" placeholder="Enter a course identifier eg: CRS-MBOR-1">
                    <el-button slot="append" @click="findCourse" :disabled="isEnrollingUser" :loading="isEnrollingUser">Enroll</el-button>
                </el-input>
            </el-tab-pane>
        </el-tabs>
    </div>
</template>

<script>
import axios from 'axios';
import EmptyState from '../../components/EmptyState';

export default {
	components: { EmptyState },
	data() {
		return {
			activeTab: 'enrollments',
			enrollQuery: '',
			isEnrollingUser: false,
			enrollments: [],
			isConfirmingUnenroll: false,
			enrollmentId: -1
		};
	},
	methods: {
		async findCourse() {
			try {
				this.isEnrollingUser = true;
				const response = await axios.get(
					`/course/search?identifier=${this.enrollQuery}`
				);

				this.enrollUser(response.data.id);
			} catch (err) {
				this.$message.error(
					`Could not find a course with identifier '${this.enrollQuery}'.`
				);
				this.isEnrollingUser = false;
			}
		},
		async enrollUser(id) {
			try {
				const response = await axios.post(`/enrollment?courseId=${id}`);
				if (response.status === 201) {
					this.$message({
						message: 'Successfully enrolled in course.',
						type: 'success'
					});
				}

				this.isEnrollingUser = false;
				this.enrollQuery = '';
				this.getEnrollments();
			} catch (err) {
				this.$message.error(`${err.response.data.errors[0]}.`);
				this.isEnrollingUser = false;
			}
		},
		async getEnrollments() {
			const response = await axios.get('/enrollment/student/all');
			this.enrollments = response.data;
		},
		async unenrollFromCourse() {
			try {
				const response = await axios.delete(
					`/enrollment?id=${this.enrollmentId}`
				);

				if (response.status === 200) {
					this.$message({
						message: 'Successfully unenrolled from course.',
						type: 'success'
					});
					this.getEnrollments();
				}

				this.isConfirmingUnenroll = false;
			} catch (err) {
				this.$message.error('Something went wrong while unenrolling you.');
				this.isConfirmingUnenroll = false;
			}
		},
		confirmUnenroll(enrollmentId) {
			this.isConfirmingUnenroll = true;
			this.enrollmentId = enrollmentId;
		}
	},
	activated() {
		this.getEnrollments();
	}
};
</script>

<style lang="scss">
#enroll-message {
	color: rgba(0, 0, 0, 0.54);
	font-size: 13px;
	margin-bottom: 16px;
}

.student-enrollments:nth-child(1) {
	padding-top: 0px;
}

.student-enrollments {
	color: rgba(0, 0, 0, 0.54);
	font-size: 13px;
	border-bottom: 1px solid rgb(212, 212, 212);
	display: flex;
	justify-content: space-between;
	padding: 16px 0px;

	&:hover {
		cursor: pointer;
	}

	p:nth-child(1) {
		font-size: 18px;
		color: rgba(0, 0, 0, 0.8);
	}

	p:nth-child(2) {
		span:nth-child(1) {
			margin: 0px 8px;
			color: rgb(212, 212, 212);
		}
	}
}
</style>
