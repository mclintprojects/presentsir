<template>
    <div>
        <navbar>
            <div @click="navigateTo('teacher-dashboard')" class="main-menu-item" :class="{highlight: shouldHighlight('teacher-dashboard')}">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530444774/present-sir/twotone-dashboard-24px.svg" />
                <p>Dashboard</p>
            </div>
            <div @click="navigateTo('teacher-courses')" class="main-menu-item" :class="{highlight: shouldHighlight('teacher-courses')}">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-class-24px.svg" />
                <p>Courses</p>
            </div>
            <div class="main-menu-item">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445880/present-sir/twotone-school-24px.svg" />
                <p>Attendance</p>
            </div>
            <div class="main-menu-item hidden">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445995/present-sir/twotone-settings-24px.svg" />
                <p>Settings</p>
            </div>
            <div class="main-menu-item" @click="logoutUser">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530450965/present-sir/twotone-exit_to_app-24px.svg" />
                <p>Logout</p>
            </div>
        </navbar>
        <div>
            <keep-alive>
                <router-view></router-view>
            </keep-alive>
        </div>
    </div>
</template>

<script>
import Navbar from '../../components/Navbar';
import eventbus from '../../eventbus';

const TOP_LEVEL_ROUTES = ['teacher-dashboard', 'teacher-courses'];
export default {
	components: { Navbar },
	data() {
		return {
			collapsed: true,
			selectedComponent: 'teacher-dashboard'
		};
	},
	computed: {},
	methods: {
		shouldHighlight(name) {
			return name === this.selectedComponent;
		},
		logoutUser() {
			this.$store.dispatch('logout');
			this.$router.push('/');
		},
		navigateTo(name) {
			this.$router.push({ name });
			this.selectedComponent = name;
		},
		highlight(to) {
			TOP_LEVEL_ROUTES.forEach(route => {
				if (to.name == route) this.selectedComponent = route;
			});
		}
	},
	watch: {
		$route(to, from) {
			this.highlight(to);
		}
	},
	created() {
		this.highlight(this.$route);
		if (this.$route.path === '/teacher')
			this.$router.push({ name: 'teacher-dashboard' });
		this.$store.dispatch('setUser');

		eventbus.$on(
			'navigatedToChildRoute',
			component => (this.selectedComponent = component)
		);
	}
};
</script>

<style lang="scss">
</style>
