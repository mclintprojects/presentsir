<template>
    <div class="app-container">
        <el-row :gutter="32">
            <el-col :sm="24" :lg="20">
                <el-input placeholder="Search for a class" size="medium">
                    <el-button slot="append">Search</el-button>
                </el-input>
            </el-col>
            <el-col :sm="24" :lg="4">
                <el-button @click="showAddCourseDialog = true" id="add-class-btn" type="danger" size="medium" icon="el-icon-plus" round>Add course</el-button>
            </el-col>
        </el-row>
		<el-table @cell-click="cellClicked" :data="courses" stripe style="margin-top: 16px; width: 100%;" empty-text="You haven't added any courses yet.">
			<el-table-column prop="identifier" label="Identifier" :min-width="130" />
			<el-table-column prop="name" label="Name" :min-width="150" />
			<el-table-column prop="course_code" label="Course code" :min-width="110" />
		</el-table>
		<div class="flex center-horizontal" style="margin-top: 16px;">
			<el-pagination layout="pager" :total="pagination.total_count" :page-size="30" />
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
		courses() {
			return this.$store.getters.courses;
		},
		pagination() {
			return this.$store.getters.coursesPagination || { total_count: 0 };
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
		cellClicked(row, col) {
			console.log({ col });
			alert(row.id);
		}
	},
	activated() {
		this.$store.dispatch('getCourses');
	}
};
</script>

<style lang="scss">
@media screen and (max-width: 567px) {
	#add-class-btn {
		margin-top: 16px;
		float: right;
	}
}
</style>
