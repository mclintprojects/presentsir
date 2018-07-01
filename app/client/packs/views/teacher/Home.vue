<template>
    <div>
        <navbar>
            <div class="main-menu-item">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530444774/present-sir/twotone-dashboard-24px.svg" />
                <p>Dashboard</p>
            </div>
            <div class="main-menu-item">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-class-24px.svg" />
                <p>Classes</p>
            </div>
            <div class="main-menu-item">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445880/present-sir/twotone-school-24px.svg" />
                <p>Attendance</p>
            </div>
            <div class="main-menu-item">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445995/present-sir/twotone-settings-24px.svg" />
                <p>Settings</p>
            </div>
            <div class="main-menu-item">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530450965/present-sir/twotone-exit_to_app-24px.svg" />
                <p>Logout</p>
            </div>
        </navbar>
        <div class="container">
            <h1>Hello, !</h1>
        </div>
    </div>
</template>

<script>
import Navbar from '../../components/Navbar';
export default {
	components: { Navbar },
	data() {
		return {
			collapsed: true
		};
	},
	computed: {},
	methods: {},
	created() {
		if (this.$route.path === '/teacher')
			this.$router.push({ name: 'teacher-dashboard' });
		this.$store.dispatch('setUser');
	}
};
</script>

<style lang="scss">
.dashboard-container {
	padding: 16px;
}
</style>
