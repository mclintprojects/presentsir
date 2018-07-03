<template>
    <div class="app-container">
        <el-row>
            <el-col :span="6" :xs="24">
                <el-date-picker type="date" style="width: 100%" v-model="date" placeholder="Pick a day" />
            </el-col>
            <el-col :span="18" :xs="24">
                <el-input v-model="date" placeholder="Enter a course identifier">
                    <el-button slot="append">View</el-button>
                </el-input>
            </el-col>
        </el-row>
        <ul id="attendances" v-if="attendances.length > 0">
            <p>Viewing attendance for {{attendances[0].course.name}}</p>
            <li v-for="(attendance, index) in attendances" :key="index">
                <p>{{attendance.student.name}}</p>
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
export default {
	components: { EmptyState },
	data() {
		return {
			date: '',
			attendances: []
		};
	}
};
</script>

<style>
</style>
