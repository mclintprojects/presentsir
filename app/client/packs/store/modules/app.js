import axios from 'axios';

const state = {
	user: {}
};

const getters = {
	user: state => state.user
};

const mutations = {
	setUser: (state, user) => (state.user = user),
	logout: state => (state.user = {})
};

const actions = {
	setUser: async ({ commit }) => {
		const response = await axios.get('/auth/get_session');
		commit('setUser', response.data.user);
	},
	logout: async ({ commit }) => {
		const response = await axios.post('/auth/logout');
		commit('logout');
	}
};

export default {
	state,
	getters,
	mutations,
	actions
};
