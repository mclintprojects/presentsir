<template>
    <div class="app-container">
        <el-row>
            <el-col :xs="24" :sm="16" :lg="16">
                <p id="course-name">{{course.name}}</p>
                <p id="course-subdetails">{{course.course_code}} <span :class="{hidden:!course.course_code}">|</span> Identifier: <span>{{course.identifier}}</span></p>
            </el-col>
            <el-col :xs="24" :sm="8" :lg="8" class="flex center-horizontal" id="course-detail-actions">
                <el-button :loading="isChangingAttendanceState" :disabled="isChangingAttendanceState" 
				@click="markAttendance(true)" v-if="!course.is_logging_attendance" icon="el-icon-tickets"
				size="small" round>Start marking attendance</el-button>

				<el-button :loading="isChangingAttendanceState" :disabled="isChangingAttendanceState"
				@click="markAttendance(false)" v-if="course.is_logging_attendance" type="danger"
				icon="el-icon-circle-close-outline" size="small" round>End attendance marking</el-button>
            </el-col>
        </el-row>
        <el-tabs style="margin-top: 16px" v-model="activeTab">
			<el-tab-pane v-if="course.is_logging_attendance" label="Ongoing attendance marking session" name="attendance-session">
				<div v-if="attendances.length === 0" style="min-height: 40vh;" class="flex center-vertical center-horizontal">
					<empty-state
						src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445880/present-sir/twotone-school-24px.svg"
						title="Course attendance" subtitle="No one has marked themself as present in this course yet." />
				</div>
				<ul class="two-title-list">
					<li class="flex center-vertical" v-for="(attendance, index) in attendances" :key="index">
						<div>
							<p>{{attendance.student.name}}</p>
							<p>{{attendance.student.email}}</p>
						</div>
					</li>
				</ul>
			</el-tab-pane>
        </el-tabs>
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
			activeTab: 'attendance-session',
			isChangingAttendanceState: false,
			attendances: []
		};
	},
	computed: {
		channel_name() {
			return `present-sir-${this.$store.getters.user.id}`;
		}
	},
	methods: {
		getDateString(date) {
			return eventbus.getDate(date);
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

				if (state) {
					this.activeTab = 'attendance-session';
					this.getAttendances();
				}
			}
			this.isChangingAttendanceState = false;
		},
		async getAttendances() {
			const response = await axios.get(
				`/attendance?identifier=${
					this.course.identifier
				}&date=${new Date().toDateString()}`
			);

			if (response.status === 200) this.attendances = response.data;
		},
		subscribe() {
			const channel = this.$pusher.subscribe(this.channel_name);
			channel.bind(
				'mark_attendance',
				function(data) {
					if (data.id === this.course.id)
						this.course.is_logging_attendance = data.state;
				}.bind(this)
			);

			channel.bind(
				'course-attend',
				function(data) {
					if (data.course_id === this.course.id) {
						this.attendances.push(data.attendance);
					}
				}.bind(this)
			);
		}
	},
	async created() {
		eventbus.$emit('navigatedToChildRoute', 'student-course-rep');

		const id = this.$route.params.id;
		const course = this.$route.params.courses;
		if (course) this.course = course;
		else {
			const response = await axios.get(`/course/search?id=${id}`);
			this.course = response.data;
		}

		this.subscribe();
		this.getAttendances();
		this.$store.dispatch('isLoading', false);
	},
	destroyed() {
		this.$pusher.unsubscribe(this.channel_name);
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

.two-title-list {
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
