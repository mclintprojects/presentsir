import Vue from 'vue';
import router from './router';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import 'babel-polyfill';
import store from './store/store';

Vue.config.productionTip = false;

Vue.use(ElementUI);
import App from '../app.vue';

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
