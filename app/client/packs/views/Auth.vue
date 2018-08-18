<template>
  <div id="auth-container" class="shadow">
	<div id="auth-nav" class="flex center-vertical">
		<p>Present, Sir</p>
		<div>
			<el-button round @click="showSignupDialog = true" size="small">Get started</el-button>
			<el-button round @click="resumeSessionOrLogin" size="small" type="primary">Login</el-button>
		</div>
	</div>

	<div>
		<section id="banner" class="landing-section flex center-vertical">
			<div>
				<p>Everything you need to manage your class attendance</p>
				<p>Present, Sir brings all the pieces together to make managing your class attendance <b>easy as ABC.</b></p>

				<el-button round @click="showSignupDialog = true" size="small">Get started</el-button>
			</div>
			<img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1534623555/present-sir/Screen_Shot_2018-08-18_at_19.59.17.png" alt="dashboard">
		</section>

		<section id="features">
			<h1>Features</h1>
			<div id="features-container">
				<div class="feature">
					<img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-class-24px.svg" alt="courses-icon">
					<p>Manage courses</p>
					<p>Add courses that you teach. Assign a course rep. View course enrollments.</p>
				</div>
				<div class="feature">
					<img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-class-24px.svg" alt="courses-icon">
					<p>Attendance statistics</p>
					<p>View course attendance statistics for any day. Export data to CSV for use in alloting marks.</p>
				</div>
				<div class="feature">
					<img src="https://res.cloudinary.com/mclint-cdn/image/upload/v1530445329/present-sir/twotone-class-24px.svg" alt="courses-icon">
					<p>Mark attendance</p>
					<p>Start a real-time attendance marking session and allow students to mark themselves as present in your class.</p>
				</div>
			</div>
		</section>
	</div>

	<el-dialog title="Login" :visible.sync="showLoginDialog" :before-close="dialogClose">
		<div class="auth-dialog">
			<label>Email address</label>
			<el-input v-model="loginData.email" class="input" placeholder="Email address" />

			<label>Password</label>
			<el-input @keyup.enter.native="loginUser" v-model="loginData.password" class="input" placeholder="Password" type="password" />

			<div>
				<el-radio v-model="loginData.user_type" label="teacher">Teacher</el-radio>
				<el-radio v-model="loginData.user_type" label="student">Student</el-radio>
			</div>

			<el-row type="flex" justify="end" style="margin-top: 16px;">
				<el-button type="success" round @click="loginUser" :disabled="isLoggingIn" :loading="isLoggingIn">Login</el-button>
			</el-row>

			<error-bag :errors="loginErrors" />
		</div>
	</el-dialog>

	<el-dialog title="Signup" :visible.sync="showSignupDialog" :before-close="dialogClose">
		<div class="auth-dialog">
			<label>First name</label>
			<el-input v-model="signupData.first_name" class="input" placeholder="First name" />

			<label>Last name</label>
			<el-input v-model="signupData.last_name" class="input" placeholder="Last name" />

			<label>Email address</label>
			<el-input v-model="signupData.email" class="input" placeholder="Email address" type="email"/>

			<label>Password</label>
			<el-input @keyup.enter.native="loginUser" v-model="signupData.password" class="input" placeholder="Password" type="password" />

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
import ErrorBag from '../components/ErrorBag';

export default {
	components: { ErrorBag },
	data() {
		return {
			showLoginDialog: false,
			showSignupDialog: false,
			isSigningUp: false,
			isLoggingIn: false,
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
				this.signupErrors = [];
				const response = await axios.post('/users/signup', this.signupData);
				if (response.status === 201) {
					const whereTo =
						this.signupData.user_type === 'teacher'
							? 'teacher-home'
							: 'student-home';

					this.$router.push({ name: whereTo });
					this.isSigningUp = false;
				}
			} catch (err) {
				this.signupErrors = err.response.data.errors;
				this.isSigningUp = false;
			}
		},
		async loginUser() {
			try {
				this.isLoggingIn = true;
				this.loginErrors = [];

				const response = await axios.post('/users/login', this.loginData);
				if (response.status === 200) this.proceedToLogin(response.data);
			} catch (err) {
				this.loginErrors = err.response.data.errors;
				this.isLoggingIn = false;
			}
		},
		proceedToLogin(user) {
			const whereTo =
				user.user_type === 'teacher' ? 'teacher-home' : 'student-home';

			this.$store.dispatch('setUser', user);
			this.$router.push({ name: whereTo });
		},
		async resumeSessionOrLogin() {
			const response = await axios.get('/auth/get_session');
			if (response.data.user) this.proceedToLogin(response.data.user);
			else this.showLoginDialog = true;
		},
		dialogClose(done) {
			this.loginData = { user_type: 'teacher' };
			this.signupData = { user_type: 'teacher' };
			this.signupErrors = [];
			this.loginErrors = [];
			done();
		}
	}
};
</script>

<style lang="scss">
#auth-container {
	display: flex;
	flex-direction: column;
	background: #e9eef3;
}

#auth-nav {
	justify-content: space-between;
	background: white;
	padding: 16px;
	position: sticky;

	> p {
		font-size: 16px;
		font-weight: bold;
	}
}

.msg-title {
	font-size: 24px;
	color: rgba(255, 255, 255, 0.8);
	text-align: center;

	span {
		font-weight: bold;
	}
}

.msg-subtitle {
	color: rgba(255, 255, 255, 0.54);
	text-align: center;
}

.landing-section {
	width: 70%;
	margin: auto;
}

#banner {
	height: calc(100vh - 64px);
	justify-content: space-between;
	> div {
		width: 30%;
		p:nth-child(1) {
			font-size: 40px;
			font-weight: bold;
			font-family: 'Alfa Slab One', Arial, Helvetica, sans-serif;
			color: rgba(0, 0, 0, 0.8);
			margin-bottom: 16px;

			+ p {
				font-size: 14px;
				margin-bottom: 16px;
				color: rgba(0, 0, 0, 0.54);
			}
		}

		+ img {
			width: 800px;
			box-shadow: 0px 0px 10px 0px rgb(219, 219, 219);
		}
	}
}

#features {
	background: white;
	padding: 30px;

	h1 {
		margin-bottom: 24px;
	}

	#features-container {
		display: flex;
		justify-content: center;

		.feature {
			width: 20%;
			padding: 24px;
			display: flex;
			flex-direction: column;
			text-align: center;
			min-height: 200px;
			margin-right: 32px;

			img {
				height: 48px;
			}

			p:nth-child(2) {
				font-size: 14px;
				color: rgba(0, 0, 0, 0.8);
				font-weight: bold;
				margin-bottom: 16px;
				margin-top: 8px;
				text-transform: uppercase;
			}

			p:nth-child(3) {
				font-size: 14px;
				color: rgba(0, 0, 0, 0.54);
			}
		}
	}
}
</style>
