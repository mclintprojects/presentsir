<template>
    <div class="app-container">
        <el-row :gutter="32">
            <el-col span="20">
                <el-input placeholder="Search for a class" size="medium">
                    <el-button slot="append">Search</el-button>
                </el-input>
            </el-col>
            <el-col span="4">
                <el-button type="danger" size="medium" icon="el-icon-plus" round>Add class</el-button>
            </el-col>
        </el-row>
    </div>
</template>

<script>
export default {};
</script>

<style>
</style>
