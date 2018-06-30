<template>
  <div id="auth-container">
    <div id="app-logo-container">
      <img id="app-logo" src="" />
    </div>

    <p style="margin-top: 24px;" class="msg-title">Welcome to <span>Present, Sir</span></p>
    <p class="msg-subtitle">Class attendance logging made easy.</p>

    <el-row id="auth-buttons-container">
      <el-button type="info" round @click="showLoginDialog = true">Login</el-button>
      <el-button type="info" round @click="showSignupDialog = true">Signup</el-button>
    </el-row>

		<el-dialog title="Login" :visible.sync="showLoginDialog">
			<div class="auth-dialog">
        <label>Username</label>
        <el-input class="input" placeholder="Username" />

        <label>Password</label>
        <el-input class="input" placeholder="Password" type="password" />

        <div>
            <el-radio v-model="user" label="teacher">Teacher</el-radio>
            <el-radio v-model="user" label="student">Student</el-radio>
        </div>

        <el-row type="flex" justify="end" style="margin-top: 16px;">
            <el-button type="success" round>Login</el-button>
        </el-row>
    	</div>
		</el-dialog>

		<el-dialog title="Signup" :visible.sync="showSignupDialog">
			<div class="auth-dialog">
        <label>Email address</label>
        <el-input class="input" placeholder="Email address" type="email"/>

        <label>Password</label>
        <el-input class="input" placeholder="Password" type="password" />

        <div>
            <el-radio v-model="user" label="teacher">Teacher</el-radio>
            <el-radio v-model="user" label="student">Student</el-radio>
        </div>

        <el-row type="flex" justify="end" style="margin-top: 16px;">
            <el-button type="success" round>Signup</el-button>
        </el-row>
    	</div>
		</el-dialog>
  </div>
</template>

<script>
export default {
	data() {
		return {
			showLoginDialog: false,
			showSignupDialog: false,
			user: 'teacher'
		};
	},
	methods: {
		navigateToSignUp() {
			this.$router.push({ name: 'signup' });
		}
	}
};
</script>

<style lang="scss">
#auth-container {
	height: 100vh;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
}

#app-logo-container {
	width: 150px;
	height: 150px;
	background-color: white;
	border-radius: 50%;
	box-shadow: 0px 4px 4px 0px rgba(199, 199, 199, 0.3);
}

.msg-title {
	font-size: 24px;
	color: var(--primary-text-color);
	text-align: center;

	span {
		font-weight: bold;
	}
}

.msg-subtitle {
	color: var(--primary-text-color-light);
	text-align: center;
}

#auth-buttons-container {
	margin-top: 40px;
}

.auth-dialog {
	.input {
		margin-bottom: 16px;
		margin-top: 4px;
	}
}

.el-dialog {
	width: 30% !important;
}

@media screen and (max-width: 567px) {
	.el-dialog {
		width: 90% !important;
	}
}
</style>
