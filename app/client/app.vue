<template>
  <div id="app">
	<div v-if="isLoading" class="loading-circle"><i class="el-icon-loading"></i></div>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
	computed: {
		isLoading() {
			return this.$store.getters.isLoading;
		}
	}
};
</script>


<style lang="scss">
:root {
	--background-color: #e9eef3;
	--primary-color: #323a4b;
	--accent-color: #fe0040;
	--primary-text-color: rgba(0, 0, 0, 0.8);
	--primary-text-color-light: rgba(0, 0, 0, 0.54);
}

* {
	margin: 0;
	padding: 0;
}

body {
	background-color: var(--background-color);
}

#app {
	font-family: 'Muli', Arial, Helvetica, sans-serif !important;
	color: var(--primary-text-color);
}

.container {
	width: 30%;
	margin: auto;
}

.container-full {
	min-height: 100vh;
}

.loading-circle {
	position: absolute;
	top: calc(50% - 18px);
	left: calc(50% - 18px);
	border-radius: 50%;
	background: #a7b1c3;
	width: 36px;
	height: 36px;
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 9000;

	i {
		color: white;
	}
}

.flex {
	display: flex;
	flex-wrap: wrap;
}

.flex-column {
	flex-direction: column;
}

.center-vertical {
	align-items: center;
}

.center-horizontal {
	justify-content: center;
}

.hidden {
	display: none !important;
}

.input {
	margin-bottom: 16px;
	margin-top: 4px;
}

.error-container {
	background-color: rgb(228, 63, 77);
	color: var(--primary-text-color-light);
	border-radius: 10px;
	padding: 16px;
	margin-top: 16px;

	.error-title {
		font-weight: bold;
	}

	ol {
		margin-left: 12px;
	}

	li {
		font-size: 12px;
	}
}

.el-dialog {
	width: 30% !important;
}

.el-table__row {
	&:hover {
		cursor: pointer;
	}
}

.app-container {
	padding: 16px;
	margin: auto;
	width: 50%;
}

ul {
	list-style-type: none;
}

.shadow {
	box-shadow: 0px 2px 6px 0px rgb(231, 231, 231);
}

.courses-list {
	margin-top: 24px;
	list-style-type: none;

	li {
		color: rgba(0, 0, 0, 0.54);
		margin-bottom: 16px;
		background: white;
		padding: 16px;
		border-radius: 5px;

		&:hover {
			cursor: pointer;
			background-color: hsl(210, 29%, 83%);
		}

		div {
			p:nth-child(1) {
				font-weight: bold;
				color: rgba(0, 0, 0, 0.8);
			}

			p:nth-child(2) {
				font-size: 13px;

				span:nth-child(1) {
					margin: 0px 8px;
					color: rgb(212, 212, 212);
				}
			}
		}
	}
}

$primary-text-color-light: rgba(0, 0, 0, 0.54);

.dashboard-greeting {
	font-size: 22px;
}

.dashboard-date {
	color: $primary-text-color-light;
	text-transform: uppercase;
	font-size: 10px;
}

@media only screen and (max-width: 567px) {
	.container {
		width: 95%;
	}

	.el-dialog {
		width: 90% !important;
	}

	.app-container {
		width: calc(100% - 32px);
	}
}
</style>
