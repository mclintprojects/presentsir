<template>
    <div class="dashboard-container">
        <p class="dashboard-greeting">Hello, {{user.first_name}}!</p>
        <p class="dashboard-date">{{date}}</p>
    </div>
</template>

<script>
import eventbus from '../../eventbus';

export default {
	data() {
		return {
			date: ''
		};
	},
	computed: {
		user() {
			return this.$store.getters.user;
		}
	},
	activated() {
		this.date = eventbus.getDate();
	}
};
</script>

<style lang="scss">
$primary-text-color: rgba(0, 0, 0, 0.8);
$primary-text-color-light: rgba(0, 0, 0, 0.54);

.dashboard-container {
	width: 80%;
	margin: auto;
	color: $primary-text-color;
}

.dashboard-greeting {
	font-size: 22px;
}

.dashboard-date {
	color: $primary-text-color-light;
	text-transform: uppercase;
	font-size: 10px;
}
</style>
