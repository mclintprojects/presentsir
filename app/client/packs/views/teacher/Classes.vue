<template>
    <div class="app-container">
        <el-row :gutter="32">
            <el-col :sm="24" :lg="20">
                <el-input placeholder="Search for a class" size="medium">
                    <el-button slot="append">Search</el-button>
                </el-input>
            </el-col>
            <el-col :sm="24" :lg="4">
                <el-button id="add-class-btn" type="danger" size="medium" icon="el-icon-plus" round>Add class</el-button>
            </el-col>
        </el-row>
    </div>
</template>

<script>
export default {};
</script>

<style lang="scss">
@media screen and (max-width: 567px) {
	#add-class-btn {
		margin-top: 16px;
		float: right;
	}
}
</style>
