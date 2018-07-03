<template>
    <div class="app-container">
        <el-row>
            <el-col :span="6" :xs="24">
                <el-date-picker type="date" style="width: 100%" v-model="date" placeholder="Pick a day" />
            </el-col>
            <el-col :span="18" :xs="24">
                <el-input v-model="identifier" placeholder="Enter a course identifier">
                    <el-button @click="getAttendances" slot="append" :loading="isGettingAttendances" :disabled="isGettingAttendances">View</el-button>
                </el-input>
            </el-col>
            <el-col :span="24" style="margin-top: 16px">
                <el-input v-model="query" placeholder="Search for a student" />
            </el-col>
        </el-row>
        <ul id="attendances" v-if="attendances.length > 0">
            <p id="viewing-attendance-label">
                Viewing ({{attendances.length}}) {{attendances.length === 1 ? 'attendance' : 'attendances'}}
                for <span>{{attendances[0].course.name}}</span> on <span>{{getDateString()}}</span>
            </p>
            <li v-for="(attendance, index) in filtered_attendances" :key="index">
                <p>{{attendance.student.name}}</p>
                <p>{{attendance.student.email}}</p>
            </li>
        </ul>
        <div v-if="attendances.length === 0" style="min-height: 60vh;" class="flex center-vertical center-horizontal">
            <empty-state
                src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530649206/present-sir/twotone-school-24px.svg"
                title="Attendances" subtitle="No one attended class on this day." />
        </div>
    </div>
</template>

<script>
import EmptyState from '../../components/EmptyState';
import axios from 'axios';
import eventbus from '../../eventbus';

export default {
	components: { EmptyState },
	data() {
		return {
			date: '',
			identifier: '',
			attendances: [],
			isGettingAttendances: false,
			query: ''
		};
	},
	computed: {
		filtered_attendances() {
			return this.attendances.filter(attendance => {
				return (
					attendance.student.name.includesInvariant(this.query) ||
					attendance.student.email.includesInvariant(this.query)
				);
			});
		}
	},
	methods: {
		async getAttendances() {
			this.isGettingAttendances = true;
			const response = await axios.get(
				`/attendance?date=${this.date}&identifier=${this.identifier}`
			);
			this.attendances = response.data;
			this.isGettingAttendances = false;
		},
		getDateString() {
			return eventbus.getDate(this.date);
		}
	}
};
</script>

<style lang="scss">
#attendances {
	margin-top: 16px;

	#viewing-attendance-label {
		font-size: 13px;
		color: rgba(0, 0, 0, 0.54);

		span {
			font-size: 16px;
			color: rgba(0, 0, 0, 0.8);
		}
	}

	li {
		padding: 16px 0px;
		border-bottom: 1px solid rgb(212, 212, 212);

		p:nth-child(1) {
			font-size: 16px;
			color: rgba(0, 0, 0, 0.8);
		}

		p:nth-child(2) {
			font-size: 13px;
			color: rgba(0, 0, 0, 0.53);
		}
	}
}
</style>
