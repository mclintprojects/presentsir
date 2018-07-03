import Vue from 'vue';
import router from './router';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import 'babel-polyfill';
import store from './store/store';
import App from '../app.vue';

Vue.config.productionTip = false;

Vue.use(ElementUI);
Vue.use(require('vue-pusher'), {
	api_key: '43b3fd68ee3ea94a9312',
	options: {
		cluster: 'eu',
		encrypted: true
	}
});

document.addEventListener('DOMContentLoaded', () => {
	const el = document.body.appendChild(document.createElement('hello'));
	const app = new Vue({
		el,
		render: h => h(App),
		router,
		store
	});
});

String.prototype.includesInvariant = function(query) {
	return this.toLowerCase().includes(query.toLowerCase());
};
