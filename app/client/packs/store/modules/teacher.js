import axios from 'axios';

const state = {
	courseData: {
		courses: []
	}
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
	getCourses: async ({ commit }, page = 1) => {
		try {
			commit('isLoading', true);
			const response = await axios.get(`/course/all?pageNumber=${page}`);
			commit('setCourseData', response.data);
			commit('isLoading', false);
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
