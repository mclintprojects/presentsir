<template>
    <div class="app-container">
        <p class="dashboard-greeting">Welcome back, {{user.first_name}}!</p>
        <p class="dashboard-date">{{date}}</p>

		<div id="dashboard-container">
			<div id="quick-stats-container" class="flex center-vertical">
				<div class="stat-item">
					<div>
						<img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530599979/present-sir/twotone-check_circle-24px.svg" />
					</div>
					<div>
						<p>Enrolled students</p>
						<p>{{stats.total_enrolled}}</p>
					</div>
				</div>
				<div class="stat-item">
					<div>
						<img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445880/present-sir/twotone-school-24px.svg" />
					</div>
					<div>
						<p>All-time attendance</p>
						<p>{{stats.total_attendance}}</p>
					</div>
				</div>
				<div class="stat-item">
					<div>
						<img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445880/present-sir/twotone-school-24px.svg" />
					</div>
					<div>
						<p>Attendance today</p>
						<p>{{stats.attendance_today}}</p>
					</div>
				</div>
				<div class="stat-item">
					<div>
						<img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530649206/present-sir/twotone-supervisor_account-24px.svg" />
					</div>
					<div>
						<p>Course reps</p>
						<p>{{stats.course_reps}}</p>
					</div>
				</div>
			</div>

			<div v-if="courses.length > 0" style="margin-top: 24px;">
				<p style="font-size: 13px; color: rgba(0, 0, 0, 0.54)">Enrollments in your courses</p>
				<ul class="courses-list" style="margin-top: 8px">
					<li class="flex dashboard-course" v-for="(course, index) in courses" :key="index">
						<div>
							<p>{{course.name}}</p>
							<p>{{course.course_code}} <span :class="{hidden:!course.course_code}">|</span> Identifier: <span>{{course.identifier}}</span></p>
						</div>
						<p>{{course.enrollments}}</p>
					</li>
				</ul>
			</div>
		</div>
    </div>
</template>

<script>
import eventbus from '../../eventbus';
import axios from 'axios';

export default {
	data() {
		return {
			date: '',
			stats: {
				total_enrolled: 0,
				total_attendance: 0,
				attendance_today: 0,
				total_courses: 0,
				course_reps: 0
			},
			courses: []
		};
	},
	computed: {
		user() {
			return this.$store.getters.user;
		}
	},
	methods: {
		async getStats() {
			try {
				this.$store.dispatch('isLoading', true);
				const response = await axios.get('/dashboard/stats');
				if (response.status === 200) {
					this.stats = response.data.stats;
					this.courses = response.data.courses;
					this.$store.dispatch('isLoading', false);
				}
			} catch (err) {}
		}
	},
	created() {
		this.date = eventbus.getDate();
		this.getStats();
	}
};
</script>

<style lang="scss">
$primary-text-color: rgba(0, 0, 0, 0.8);
$primary-text-color-light: rgba(0, 0, 0, 0.54);

#dashboard-container {
	margin-top: 24px;
}

#quick-stats-container {
	justify-content: space-between;
}

.stat-item {
	background: white;
	display: flex;
	border-radius: 10px;
	box-shadow: 0px 2px 6px 0px rgb(231, 231, 231);
	margin-bottom: 16px;
	width: 48%;

	div {
		display: flex;
		padding: 16px;
	}

	div:nth-child(1) {
		justify-content: center;
		width: 30px;
		background: hsl(210, 29%, 96%);
		border-radius: 10px 0px 0px 10px;
	}

	div:nth-child(2) {
		flex-direction: column;
		text-align: left;
		color: rgba(0, 0, 0, 0.54);

		p:nth-child(2) {
			font-size: 26px;
			color: rgba(0, 0, 0, 0.8);
			font-weight: bold;
		}

		p:nth-child(1) {
			font-size: 11px;
			text-transform: uppercase;
		}
	}
}

.dashboard-course {
	justify-content: space-between;
	align-items: center;

	&:hover {
		cursor: default !important;
		background: white !important;
	}
}

.dashboard-course > p {
	font-size: 24px;
	font-weight: bold;
}

@media only screen and (max-width: 567px) {
	#dashboard-container {
		margin-top: 16px;
	}

	.stat-item {
		margin-right: 0px;
		width: 100%;
	}
}
</style>
