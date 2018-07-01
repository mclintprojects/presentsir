<template>
    <div>
        <h1>Welcome, {{user.first_name}}!</h1>
    </div>
</template>

<script>
export default {
	computed: {
		user() {
			return this.$store.getters.user;
		}
	}
};
</script>

<style>
</style>
