import Vue from 'vue';
import axios from 'axios';
import store from './store/store';
import Router from 'vue-router';
import Auth from './views/Auth.vue';

import StudentHome from './views/student/Home';
import StudentCourses from './views/student/Courses';
import LogAttendance from './views/student/LogAttendance';
import CourseRep from './views/student/CourseRep';
import CourseRepCourseDetail from './views/student/CourseDetail';

import TeacherHome from './views/teacher/Home';
import TeacherDashboard from './views/teacher/Dashboard';
import TeacherCourses from './views/teacher/Courses';
import Attendance from './views/teacher/Attendance';
import CourseDetail from './views/teacher/CourseDetail';

Vue.use(Router);

const router = new Router({
	routes: [
		{
			path: '/',
			name: 'auth',
			component: Auth
		},
		{
			path: '/student',
			name: 'student-home',
			component: StudentHome,
			children: [
				{
					path: 'courses',
					name: 'student-courses',
					component: StudentCourses
				},
				{
					path: 'log-attendance',
					name: 'log-attendance',
					component: LogAttendance
				},
				{
					path: 'course_rep',
					name: 'student-course-rep',
					component: CourseRep
				},
				{
					path: 'course_rep/course/:id',
					name: 'course-rep-course-detail',
					component: CourseRepCourseDetail
				}
			],
			async beforeEnter(to, from, next) {
				const response = await axios.get('/auth/get_session');
				response.data.user.user_type == 'student' ? next() : next('/');
			}
		},
		{
			path: '/teacher',
			name: 'teacher-home',
			component: TeacherHome,
			children: [
				{
					path: 'dashboard',
					name: 'teacher-dashboard',
					component: TeacherDashboard
				},
				{
					path: 'courses',
					name: 'teacher-courses',
					component: TeacherCourses
				},
				{
					path: 'courses/:id',
					name: 'course-detail',
					component: CourseDetail
				},
				{
					path: 'attendance',
					name: 'attendance',
					component: Attendance
				}
			],
			async beforeEnter(to, from, next) {
				const response = await axios.get('/auth/get_session');
				response.data.user.user_type == 'teacher' ? next() : next('/');
			}
		}
	],
	mode: 'history'
});

const excludedPaths = ['/'];
router.beforeEach(async (to, from, next) => {
	if (!excludedPaths.includes(to.path)) {
		const response = await axios.get('/auth/get_session');
		response.data.user ? next() : next('/');
	} else next();
});

export default router;
