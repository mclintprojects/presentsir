import axios from 'axios';

const state = {
	courseData: {}
};

const getters = {
	courses: state => state.courseData.courses,
	coursesPagination: state => state.courseData.meta
};

const mutations = {
	setCourseData: (state, courseData) => (state.courseData = courseData),
	addCourse: (state, course) => {
		state.courseData.courses.push(course);
		++state.courseData.meta.total_value;
	}
};

const actions = {
	getCourses: async ({ commit }) => {
		try {
			const response = await axios.get('/course/all');
			commit('setCourseData', response.data);
		} catch (err) {}
	},
	addCourse: ({ commit }, course) => commit('addCourse', course)
};

export default {
	state,
	getters,
	mutations,
	actions
};
