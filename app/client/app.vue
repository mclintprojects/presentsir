<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

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
