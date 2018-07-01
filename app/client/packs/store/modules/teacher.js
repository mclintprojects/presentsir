import axios from 'axios';

const state = {
	courses: []
};

const getters = {
	courses: state => state.courses
};

const mutations = {
	setCourses: (state, courses) => (state.courses = courses),
	addCourse: (state, course) => state.courses.push(course)
};

const actions = {
	getCourses: async ({ commit }) => {
		try {
			const response = await axios.get('/course/all');
			commit('setCourses', response.data);
		} catch (err) {}
	},
	addCourse: ({ commit }, course) => commit('addClass', course)
};

export default {
	state,
	getters,
	mutations,
	actions
};
