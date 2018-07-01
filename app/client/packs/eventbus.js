import Vue from 'vue';

const eventbus = new Vue({
	data: {
		months: [
			'January',
			'February',
			'March',
			'April',
			'May',
			'June',
			'July',
			'August',
			'September',
			'October',
			'November',
			'December'
		]
	},
	methods: {
		getDate() {
			const date = new Date();
			return `${date.getDate()} ${
				this.months[date.getMonth()]
			}, ${date.getFullYear()}`;
		}
	}
});

export default eventbus;
