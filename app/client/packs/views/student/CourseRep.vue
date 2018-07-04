<template>
    <div class="app-container">
        <p style="color: rgba(0, 0, 0, 0.54); font-size: 13px;">
            Hello! You're a course rep and you've been assigned to the courses below.
        </p>
        <ul class="courses-list" style="margin-top: 16px">
			<li v-for="(course, index) in courses" :key="index" @click="cellClicked(course.id, course)">
				<div class="flex flex-column">
					<p>{{course.name}}</p>
					<p>{{course.course_code}} <span :class="{hidden:!course.course_code}">|</span> Identifier: <span>{{course.identifier}}</span></p>
				</div>
			</li>
		</ul>
    </div>
</template>

<script>
import axios from 'axios';

export default {
	data() {
		return { courses: [] };
	},
	methods: {
		async getCourses() {
			const response = await axios.get('/course_rep/courses');
			if (response.status === 200) this.courses = response.data;
		},
		cellClicked(id, course) {
			this.$router.push({
				name: 'course-rep-course-detail',
				params: { id, course }
			});
		}
	},
	activated() {
		this.getCourses();
	}
};
</script>

<style>
</style>
