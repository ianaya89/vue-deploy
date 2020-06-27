<template>
  <div id="app">
    <img alt="AWS logo" src="./assets/aws.png">
    <h1>Vue Deploy PoC</h1>
    <h2><a href="https://aws.amazon.com" target="_blank">aws.amazon.com (S3 + Cloud Front)</a></h2>
  </div>
</template>

<script>
export default {
  name: 'App',
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

img {
  width: 200px;
}
</style>
