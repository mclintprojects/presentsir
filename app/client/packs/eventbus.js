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
		getDate(dateString = '') {
			const date = dateString.length == 0 ? new Date() : new Date(dateString);
			return `${date.getDate()} ${
				this.months[date.getMonth()]
			}, ${date.getFullYear()}`;
		}
	}
});

export default eventbus;
