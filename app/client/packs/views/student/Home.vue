<template>
    <div>
        <navbar>
			<div slot="greeting">
				<p class="nav-greeting">Welcome back, {{user_name}}!</p>
			</div>
            <div @click="navigateTo('log-attendance')" class="main-menu-item" :class="{highlight: shouldHighlight('log-attendance')}">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445880/present-sir/twotone-assignment-24px.svg" />
                <p>Log attendance</p>
            </div>
            <div @click="navigateTo('student-courses')" class="main-menu-item" :class="{highlight: shouldHighlight('student-courses')}">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-class-24px.svg" />
                <p>Courses</p>
            </div>
			<div v-if="is_course_rep" @click="navigateTo('student-course-rep')" class="main-menu-item" :class="{highlight: shouldHighlight('student-course-rep')}">
                <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530649206/present-sir/twotone-supervisor_account-24px.svg" />
                <p>Course rep</p>
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
import axios from 'axios';

const TOP_LEVEL_ROUTES = [
	'log-attendance',
	'student-courses',
	'student-course-rep'
];
export default {
	components: { Navbar },
	data() {
		return {
			collapsed: true,
			selectedComponent: 'log-attendance',
			is_course_rep: false
		};
	},
	computed: {
		user_name() {
			return this.$store.getters.user.first_name;
		}
	},
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
		},
		async unlockIfCourseRep() {
			const response = await axios.get('/course_rep/whoami');
			if (response.status === 200)
				this.is_course_rep = response.data.is_course_rep;
		}
	},
	watch: {
		$route(to, from) {
			this.highlight(to);
		}
	},
	created() {
		this.highlight(this.$route);
		if (this.$route.path === '/student')
			this.$router.push({ name: 'log-attendance' });
		this.$store.dispatch('setUser');

		eventbus.$on(
			'navigatedToChildRoute',
			component => (this.selectedComponent = component)
		);

		this.unlockIfCourseRep();
	},
	deactivated() {
		this.is_course_rep = false;
	}
};
</script>

<style lang="scss">
</style>
