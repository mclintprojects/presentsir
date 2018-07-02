<template>
    <div class="app-container">
        <el-row>
            <el-col :sm="24" :lg="16">
                <p id="course-name">{{course.name}}</p>
                <p id="course-subdetails">{{course.course_code}} <span :class="{hidden:!course.course_code}">|</span> Identifier: <span>{{course.identifier}}</span></p>
            </el-col>
            <el-col :sm="24" :lg="8" class="flex center-horizontal" id="course-detail-actions">
                <el-button type="success" icon="el-icon-plus" size="small" round>Add a course rep</el-button>
                <el-button @click="showDeleteConfirmation = true" id="delete-course-btn" type="danger" icon="el-icon-delete" size="small" round>Delete course</el-button>
            </el-col>
        </el-row>
        <el-tabs style="margin-top: 16px" v-model="activeTab">
            <el-tab-pane label="Enrollments" name="enrollments">
                <p id="course-enrollments-count"><span>{{course.enrollments}}</span> students have enrolled in this course.</p>

            </el-tab-pane>
            <el-tab-pane label="Course reps" name="course-reps">
                
            </el-tab-pane>
        </el-tabs>
		<el-dialog :visible.sync="showDeleteConfirmation">
			<p>Are you sure you want to delete this course?</p>
			<span slot="footer" class="dialog-footer">
				<el-button @click="showDeleteConfirmation = false" round>Cancel</el-button>
				<el-button type="danger" @click="deleteCourse" :loading="isDeletingCourse" round>Delete</el-button>
			</span>
		</el-dialog>
    </div>
</template>

<script>
import axios from 'axios';
import eventbus from '../../eventbus';

export default {
	data() {
		return {
			course: {},
			activeTab: 'enrollments',
			showDeleteConfirmation: false,
			isDeletingCourse: false
		};
	},
	methods: {
		async deleteCourse() {
			try {
				this.isDeletingCourse = true;
				const response = await axios.delete(
					`/course/delete?id=${this.course.id}`
				);

				this.showDeleteConfirmation = false;
				this.$router.go(-1);
				this.isDeletingCourse = false;
			} catch (err) {
				this.$message.error(err.response.data.errors[0]);
				this.isDeletingCourse = false;
			}
		}
	},
	async activated() {
		eventbus.$emit('navigatedToChildRoute', 'teacher-courses');

		const id = this.$route.params.id;
		const courses = this.$store.getters.courses;
		if (courses.length > 0)
			this.course = courses.find(course => course.id == id);
		else {
			const response = await axios.get(`/course/search?id=${id}`);
			this.course = response.data;
		}
	}
};
</script>

<style lang="scss">
$text-color: rgba(0, 0, 0, 0.8);
$text-color-light: rgba(0, 0, 0, 0.54);

#course-name {
	font-size: 18px;
	color: $text-color;
}

#course-subdetails {
	color: $text-color-light;
	margin-top: 8px;
	font-size: 13px;
}

#course-enrollments-count {
	color: $text-color-light;
	font-size: 12px;

	span {
		font-size: 20px;
		color: $text-color;
	}
}

@media screen and (max-width: 567px) {
	#course-detail-actions {
		margin-top: 16px;
		justify-content: flex-start;
	}
}
</style>
