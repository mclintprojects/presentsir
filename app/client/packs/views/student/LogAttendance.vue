<template>
    <div class="app-container">
        <div v-if="logging_courses.length === 0" style="min-height: 60vh;" class="flex center-vertical center-horizontal">
            <empty-state
                src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445880/present-sir/twotone-assignment-24px.svg"
                title="Courses logging attendance" subtitle="No course you are enrolled in is currently logging attendance." />
        </div>

        <div style="margin-bottom: 16px;" v-if="logging_courses.length > 0">
            <p style="color: rgba(0, 0, 0, 0.54)">Courses currently logging attendance</p>
            <ul id="logging-courses" class="flex">
                <li class="shadow" v-for="(logging_course, index) in logging_courses" :key="index">
                    <p>{{logging_course.name}}</p>
                    <p>{{logging_course.course_code}}</p>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
import EmptyState from '../../components/EmptyState';

export default {
	components: { EmptyState },
	data() {
		return {
			logging_courses: []
		};
	}
};
</script>

<style>
</style>
