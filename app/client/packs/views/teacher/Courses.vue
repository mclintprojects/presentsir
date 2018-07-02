<template>
    <div class="app-container">
        <el-row :gutter="32">
            <el-col :sm="24" :lg="20">
                <el-input v-model="query" placeholder="Search for a class" size="medium" />
            </el-col>
            <el-col :sm="24" :lg="4">
                <el-button @click="showAddCourseDialog = true" id="add-class-btn" type="danger" size="medium" icon="el-icon-plus" round>Add course</el-button>
            </el-col>
        </el-row>
		<ul class="courses-list">
			<li v-for="(course, index) in courses" :key="index" @click="cellClicked(course.id)">
				<div class="flex flex-column">
					<p>{{course.name}}</p>
					<p>{{course.course_code}} <span :class="{hidden:!course.course_code}">|</span> Identifier: <span>{{course.identifier}}</span></p>
				</div>
			</li>
		</ul>
		<div class="flex center-horizontal" style="margin-top: 16px;">
			<el-pagination background layout="pager" :total="pagination.total_count" :page-size="30" @current-change="currentPageChanged" />
		</div>
        <el-dialog title="Add a new class" :visible.sync="showAddCourseDialog">
            <label>Name</label>
            <el-input class="input" v-model="formData.name" placeholder="Enter the name of the clouse" />

            <label>Course code (optional)</label>
            <el-input class="input" v-model="formData.course_code" placeholder="Enter the course code eg: IT 304" />

            <span slot="footer" class="dialog-footer">
                <el-button type="danger" @click="addCourse" :loading="isAddingCourse" :disabled="isAddingCourse" round>Add</el-button>
            </span>

            <error-bag :errors="errors" />

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
			query: '',
			showAddCourseDialog: false,
			isAddingCourse: false,
			formData: {
				name: '',
				course_code: ''
			},
			errors: []
		};
	},
	computed: {
		pagination() {
			return this.$store.getters.coursesPagination || { total_count: 1000 };
		},
		courses() {
			return this.$store.getters.courses.filter(
				course =>
					course.name.includesInvariant(this.query) ||
					course.identifier.includesInvariant(this.query) ||
					course.course_code.includesInvariant(this.query)
			);
		}
	},
	methods: {
		async addCourse() {
			try {
				this.errors = [];
				this.isAddingCourse = true;

				const response = await axios.post('/course/new', {
					course: this.formData
				});

				this.$store.dispatch('addCourse', response.data);

				this.isAddingCourse = false;
				this.showAddCourseDialog = false;
				this.formData.name = '';
				this.formData.course_code = '';
			} catch (err) {
				this.isAddingCourse = false;
				this.errors = err.response.data.errors;
			}
		},
		cellClicked(id) {
			this.$router.push({ name: 'course-detail', params: { id } });
		},
		currentPageChanged(page) {
			this.$store.dispatch('getCourses', page);
		}
	},
	activated() {
		this.$store.dispatch('getCourses');
	}
};
</script>

<style lang="scss">
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
			background-color: rgb(243, 243, 243);
		}

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
@media screen and (max-width: 567px) {
	#add-class-btn {
		margin-top: 16px;
		float: right;
	}
}
</style>
