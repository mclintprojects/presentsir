<template>
    <div>
        <el-row>
            <el-col :lg="menuWidth">
                <el-menu 
                style="min-height: 100vh"
                default-active="2"
                background-color="#323a4b"
                active-text-color="#fe0040"
                text-color="rgba(255, 255, 255, 0.8)"
                :collapse="collapsed">
                    <el-menu-item index="1" @click="collapsed = !collapsed">
                        <img class="el-icon-menu" :src="menuIcon" />
                    </el-menu-item>
                    <el-menu-item index="2">
                        <img class="el-icon-menu" src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530444774/present-sir/twotone-dashboard-24px.svg" />
                        <span slot="title">Dashboard</span>
                    </el-menu-item>
                    <el-menu-item index="3">
                        <img class="el-icon-location" src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-class-24px.svg" />
                        <span slot="title">Classes</span>
                    </el-menu-item>
                    <el-menu-item index="4">
                        <img class="el-icon-location" src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-school-24px.svg" />
                        <span slot="title">Attendance</span>
                    </el-menu-item>
                    <el-menu-item index="5">
                        <img class="el-icon-location" src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-settings-24px.svg" />
                        <span slot="title">Settings</span>
                    </el-menu-item>
                </el-menu>
            </el-col>
            <el-col class="dashboard-container" :lg="dashboardWidth">
                <keep-alive>
                    <router-link></router-link>
                </keep-alive>
            </el-col>
        </el-row>
    </div>
</template>

<script>
export default {
	data() {
		return {
			collapsed: true
		};
	},
	computed: {
		menuIcon() {
			return this.collapsed
				? 'https://res.cloudinary.com/mclint-cdn/image/upload/v1530444774/present-sir/twotone-menu-24px.svg'
				: 'https://res.cloudinary.com/mclint-cdn/image/upload/v1530444774/present-sir/twotone-arrow_back-24px.svg';
		},
		menuWidth() {
			return this.collapsed ? 1 : 3;
		},
		dashboardWidth() {
			return this.collapsed ? 22 : 20;
		}
	},
	methods: {}
};
</script>

<style lang="scss">
.dashboard-container {
	padding: 16px;
}
</style>
