<template>
    <div class="app-container">
        <div v-if="logging_courses.length > 0" style="margin-bottomL 16px;">
            <p style="color: rgba(0, 0, 0, 0.54)">Courses currently logging attendance</p>
            <ul id="logging-courses" class="flex">
                <li class="shadow" v-for="(logging_course, index) in logging_courses" :key="index">
                    <p>{{logging_course.name}}</p>
                    <p>{{logging_course.course_code}}</p>
                </li>
            </ul>
        </div>
        <el-tabs v-model="activeTab">
            <el-tab-pane label="Enrollments" name="enrollments">
				<div class="student-enrollments" v-for="(enrollment, index) in enrollments" :key="index">
					<div>
						<p>{{enrollment.course.teacher_name}}</p>
						<p>{{enrollment.course.name}}<span>|</span>{{enrollment.course.identifier}}</p>
					</div>
					<div><el-button type="danger" size="medium" round>Unenroll</el-button></div>
				</div>
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

export default {
	data() {
		return {
			logging_courses: [],
			activeTab: 'enrollments',
			enrollQuery: '',
			isEnrollingUser: false,
			enrollments: []
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
				console.log(err);
				this.$message.error(
					`Could not find a course with identifier '${this.enrollQuery}'.`
				);
				this.isEnrollingUser = false;
			}
		},
		async enrollUser(id) {
			try {
				const response = await axios.post(`/enrollment/new?courseId=${id}`);
				if (response.status === 201) {
					this.$message({
						message: 'Successfully enrolled in course.',
						type: 'success'
					});
				}

				this.isEnrollingUser = false;
				this.getEnrollments();
			} catch (err) {
				this.$message.error(err.response.data.errors[0]);
				this.isEnrollingUser = false;
			}
		},
		async getEnrollments() {
			const response = await axios.get('/enrollment/student/all');
			this.enrollments = response.data;
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

#logging-courses {
	margin-top: 8px;
	justify-content: space-between;

	li {
		background: white;
		border-radius: 10px;
		padding: 16px;
		width: 20%;
		margin-right: 16px;
		margin-bottom: 16px;

		p:nth-child(1) {
			font-size: 18px;
		}

		p:nth-child(2) {
			font-size: 10px;
			text-transform: uppercase;
			color: rgba(0, 0, 0, 0.54);
		}

		&:hover {
			cursor: pointer;
			background: hsl(210, 29%, 89%);
		}
	}
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

@media screen and (max-width: 567px) {
	#logging-courses {
		li:nth-child(even) {
			margin-right: 0px;
		}

		li {
			width: calc(50% - 48px);
		}
	}
}
</style>
