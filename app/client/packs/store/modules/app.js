import axios from 'axios';

const state = {
	user: {},
	isLoading: false
};

const getters = {
	user: state => state.user,
	isLoading: state => state.isLoading
};

const mutations = {
	setUser: (state, user) => (state.user = user),
	logout: state => (state.user = {}),
	isLoading: (state, isLoading) => (state.isLoading = isLoading)
};

const actions = {
	setUser: async ({ commit }) => {
		const response = await axios.get('/auth/get_session');
		commit('setUser', response.data.user);
	},
	logout: async ({ commit }) => {
		const response = await axios.post('/auth/logout');
		commit('logout');
	},
	setLoading: ({ commit }, isLoading) => commit('isLoading', isLoading)
};

export default {
	state,
	getters,
	mutations,
	actions
};
