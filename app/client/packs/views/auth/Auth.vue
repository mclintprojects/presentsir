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
					<el-radio v-model="loginData.user_type" label="teacher">Teacher</el-radio>
					<el-radio v-model="loginData.user_type" label="student">Student</el-radio>
				</div>

				<el-row type="flex" justify="end" style="margin-top: 16px;">
					<el-button type="success" round>Login</el-button>
				</el-row>
			</div>
		</el-dialog>

		<el-dialog title="Signup" :visible.sync="showSignupDialog">
			<div class="auth-dialog">
				<label>First name</label>
				<el-input v-model="signupData.first_name" class="input" placeholder="First name" />

				<label>Last name</label>
				<el-input v-model="signupData.last_name" class="input" placeholder="Last name" />

				<label>Email address</label>
				<el-input v-model="signupData.email" class="input" placeholder="Email address" type="email"/>

				<label>Password</label>
				<el-input v-model="signupData.password" class="input" placeholder="Password" type="password" />

				<div>
					<el-radio v-model="signupData.user_type" label="teacher">Teacher</el-radio>
					<el-radio v-model="signupData.user_type" label="student">Student</el-radio>
				</div>

				<el-row type="flex" justify="end" style="margin-top: 16px;">
					<el-button type="success" round @click="signupUser" :disabled="isSigningUp" :loading="isSigningUp">Signup</el-button>
				</el-row>

				<error-bag :errors="signupErrors" />
			</div>
		</el-dialog>
  </div>
</template>

<script>
import axios from 'axios';
import ErrorBag from '../../components/ErrorBag';

export default {
	components: { ErrorBag },
	data() {
		return {
			showLoginDialog: false,
			showSignupDialog: false,
			isSigningUp: false,
			signupData: {
				first_name: '',
				last_name: '',
				user_type: 'teacher',
				email: '',
				password: ''
			},
			loginData: {
				email: '',
				password: '',
				user_type: 'teacher'
			},
			signupErrors: [],
			loginErrors: []
		};
	},
	methods: {
		navigateToSignUp() {
			this.$router.push({ name: 'signup' });
		},
		async signupUser() {
			try {
				this.isSigningUp = true;
				const response = await axios.post('/users/signup', this.signupData);
				if (response.status === 201) {
					this.$router.push({ name: 'student-home' });
					this.isSigningUp = false;
				}
			} catch (err) {
				this.signupErrors = err.response.data.errors;
				this.isSigningUp = false;
			}
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
