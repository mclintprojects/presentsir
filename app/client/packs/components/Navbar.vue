<template>
    <div>
        <div id="nav-bar" class="flex center-vertical">
            <p id="brand-name">Present, Sir</p>
            <div class="flex center-vertical">
                <el-badge is-dot>
                    <img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530450965/present-sir/twotone-notifications-24px.svg" />
                </el-badge>
                <img @click="collapsed = !collapsed" id="main-menu-toggle" style="margin-left: 32px;" src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530446060/present-sir/twotone-menu-24px.svg" />
            </div>
        </div>
        <div :class="{hidden: collapsed}">
            <div id="main-menu"><slot></slot></div>
        </div>
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
		user() {
			return this.$store.getters.user;
		}
	},
	created() {
		this.$nextTick(() => {
			window.addEventListener('resize', () => {
				if (window.innerWidth > 567) this.collapsed = false;
			});
		});
	}
};
</script>

<style lang="scss">
#brand-name {
	font-weight: bold;
}

#nav-bar {
	padding: 16px;
	justify-content: space-between;
	background: white;
	border-bottom: 1px solid rgba(192, 192, 192, 0.3);
}

#main-menu {
	display: flex;
	align-items: center;
	justify-content: center;
	background: white;
	box-shadow: 0px 2px 6px 0px rgb(236, 236, 236);
}

#main-menu-toggle {
	display: none;

	&:hover {
		cursor: pointer;
	}
}

.main-menu-item {
	padding: 16px;
	display: flex;
	justify-content: center;
	align-items: center;
	color: rgba(0, 0, 0, 0.8);

	img {
		margin-right: 16px;
	}

	&:hover {
		background: rgb(243, 243, 243);
		border-bottom: 2px solid #fe0040;
		cursor: pointer;
	}
}

@media screen and (max-width: 567px) {
	#main-menu {
		flex-direction: column;
	}

	.main-menu-item {
		width: 100%;
		justify-content: flex-start;

		img {
			margin-left: 16px;
		}
	}

	#main-menu-toggle {
		display: initial;
	}
}
</style>
