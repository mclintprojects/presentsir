import Vue from 'vue';
import Router from 'vue-router';
import Auth from './views/auth/Auth.vue';

Vue.use(Router);

export default new Router({
	routes: [
		{
			path: '/',
			name: 'auth',
			component: Auth
		}
	],
	mode: 'history'
});
