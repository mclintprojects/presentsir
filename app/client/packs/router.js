import Vue from 'vue';
import Router from 'vue-router';
import Auth from './views/Auth.vue';
import StudentHome from './views/student/Home';
import TeacherHome from './views/teacher/Home';
import TeacherDashboard from './views/teacher/Dashboard';

Vue.use(Router);

export default new Router({
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
				}
			]
		}
	],
	mode: 'history'
});
