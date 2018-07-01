import Vue from 'vue';
import axios from 'axios';
import Router from 'vue-router';
import Auth from './views/Auth.vue';
import StudentHome from './views/student/Home';

import TeacherHome from './views/teacher/Home';
import TeacherDashboard from './views/teacher/Dashboard';
import TeacherClasses from './views/teacher/Classes';

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
			children: []
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
					path: 'classes',
					name: 'teacher-classes',
					component: TeacherClasses
				}
			]
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
