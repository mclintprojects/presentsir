<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<style lang="scss">
:root {
	--background-color: #f5f8fa;
	--primary-color: #ffffff;
	--accent-color: #58d3d3;
	--primary-text-color: rgba(0, 0, 0, 0.8);
	--primary-text-color-light: rgba(0, 0, 0, 0.54);
}

* {
	margin: 0;
	padding: 0;
}

#app {
	font-family: Arial, Helvetica, sans-serif !important;
	background-color: var(--background-color);
}

.container {
	width: 30%;
	margin: auto;
	min-height: 100vh;
}

.flex {
	display: flex;
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

.error-container {
	background-color: tomato;
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

@media screen and (max-width: 567px) {
	.container {
		width: 95%;
	}
}
</style>
