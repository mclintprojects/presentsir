<template>
    <div class="app-container">
        <div v-if="logging_enrollments.length === 0" style="min-height: 60vh;" class="flex center-vertical center-horizontal">
            <empty-state
                src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445880/present-sir/twotone-assignment-24px.svg"
                title="Courses logging attendance" subtitle="No course you are enrolled in is currently logging attendance." />
        </div>

        <div style="margin-bottom: 16px;" v-if="logging_enrollments.length > 0">
            <p style="color: rgba(0, 0, 0, 0.54); font-size: 10px; text-transform: uppercase;">Courses currently logging attendance</p>
            <ul id="logging-courses" class="flex">
                <li class="shadow" v-for="(logging_enrollment, index) in logging_enrollments" :key="index">
                    <div>
                        <p>{{logging_enrollment.course.name}}</p>
                        <p>{{logging_enrollment.course.course_code}}</p>
                    </div>
                    <div class="flex center-horizontal" style="margin-top: 16px"> 
                        <el-button :loading="isMarkingAsPresent" :disabled="isMarkingAsPresent" @click="markAsPresent(logging_enrollment.course.id)" type="success" icon="el-icon-check" round>Mark me as present</el-button>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
import EmptyState from '../../components/EmptyState';
import axios from 'axios';

export default {
	components: { EmptyState },
	data() {
		return {
			logging_enrollments: [],
			isMarkingAsPresent: false
		};
	},
	methods: {
		async getLoggingEnrollments() {
			const response = await axios.get('/enrollment/is_logging_attendance');
			this.logging_enrollments = response.data;
		},
		async markAsPresent(courseId) {
			try {
				this.isMarkingAsPresent = true;
				const response = await axios.post(`/attendance/new`, { courseId });
				this.$message({
					message: 'You have successfully marked yourself as present.',
					type: 'success'
				});

				this.isMarkingAsPresent = false;
				this.getLoggingEnrollments();
			} catch (err) {
				this.isMarkingAsPresent = false;
				this.$message.error(err.response.data.errors[0]);
			}
		}
	},
	activated() {
		this.getLoggingEnrollments();
	}
};
</script>

<style lang="scss">
#logging-courses {
	margin-top: 8px;
	justify-content: space-between;

	li {
		background: white;
		border-radius: 10px;
		padding: 16px;
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
		}
	}
}

@media only screen and (max-width: 567px) {
	#logging-courses {
		li {
			margin-right: 0px;
			width: 100%;
		}
	}
}
</style>
