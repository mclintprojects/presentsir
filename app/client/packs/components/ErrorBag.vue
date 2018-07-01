<template>
    <div v-if="errors.length > 0" class="error-container">
        <p class="error-title">{{title}}</p>
        <ol>
            <li v-for="(error, index) in errors" :key="index">
                <p>{{error}}.</p>
            </li>
        </ol>
    </div>
</template>

<script>
export default {
	props: { errors: { type: Array }, title: { type: String, default: 'Errors' } }
};
</script>

<style>
</style>
