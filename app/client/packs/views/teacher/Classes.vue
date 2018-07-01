<template>
    <div class="app-container">
        <el-row :gutter="32">
            <el-col :sm="24" :lg="20">
                <el-input placeholder="Search for a class" size="medium">
                    <el-button slot="append">Search</el-button>
                </el-input>
            </el-col>
            <el-col :sm="24" :lg="4">
                <el-button @click="showAddClassDialog = true" id="add-class-btn" type="danger" size="medium" icon="el-icon-plus" round>Add class</el-button>
            </el-col>
        </el-row>
        <el-dialog title="Add a new class" :visible.sync="showAddClassDialog">
            <label>Name</label>
            <el-input class="input" v-model="formData.name" placeholder="Enter the name of the class" />

            <label>Class code (optional)</label>
            <el-input class="input" v-model="formData.course_code" placeholder="Enter the name of the class" />

            <span slot="footer" class="dialog-footer">
                <el-button type="danger" @click="addClass" :loading="isAddingClass" :disabled="isAddingClass" round>Add</el-button>
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
			showAddClassDialog: false,
			isAddingClass: false,
			formData: {
				name: '',
				course_code: ''
			},
			errors: []
		};
	},
	methods: {
		async addClass() {
			try {
				this.isAddingClass = true;
				const response = await axios.post('/course/new', this.formData);
				this.isAddingClass = false;
			} catch (err) {
				this.isAddingClass = false;
			}
		}
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
