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
		<el-table :data="courses" style="margin-top: 16px" empty-text="You haven't added any courses yet.">
			<el-table-column prop="identifier" label="Identifier" />
			<el-table-column prop="name" label="Name" />
			<el-table-column prop="course_code" label="Course code" />
			<el-table-column>
				<template slot-scope="scope">
					<el-button size="mini" type="success" round>View</el-button>
				</template>
			</el-table-column>
		</el-table>
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
			} catch (err) {
				this.isAddingCourse = false;
				this.errors = err.response.data.errors;
			}
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
