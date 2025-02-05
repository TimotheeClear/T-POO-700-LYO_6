<script lang="ts">
import { defineComponent } from "vue";
import NavBar from "./components/navBar/NavBar.vue";

export default defineComponent({
	name: "AppView",
	components: {
		NavBar,
	},
});
</script>

<template>
	<header class="main-header">
		<NavBar />
	</header>
	<main class="main-wrapper bg-color-light">
		<router-view></router-view>
	</main>
<!--	<footer class="main-footer">-->
<!--		<div class="main-footer-content">-->
<!--			<span class="main-footer-title">⏱️ Time Manager</span>-->
<!--			<ul class="main-footer-names">-->
<!--				<li>Aziz Ben-Ayed</li>-->
<!--				<li>Xiaoyan Chen</li>-->
<!--				<li>Timothée Clear</li>-->
<!--				<li>Romain Mularczyk</li>-->
<!--			</ul>-->
<!--			<span class="main-footer-moto">A Gotham City software 💻</span>-->
<!--		</div>-->
<!--	</footer>-->
</template>

<style lang="scss">
#app {
	font-family: Avenir, Helvetica, Arial, sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	text-align: center;
	color: #0d0a0b;
	min-height: 100vh;
	background-color: #fcfcfc;
}

//.main-footer {
//	box-shadow: 0 0 7px 0 rgba(0, 0, 0, 0.5);
//	padding-top: 1%;
//	margin-top: 3em;
//	background-color: #fcfcfc;
//	// position: fixed;
//	// left: 0;
//	// bottom: 0;
//	width: 100%;
//}
//
//.main-footer-content {
//	display: grid;
//	grid-template-columns: repeat(5, 20%);
//}
//
//.main-footer-title {
//	grid-column-start: 1;
//	grid-column-end: 2;
//}
//
//.main-footer-names {
//	display: flex;
//	grid-column-start: 2;
//	grid-column-end: 5;
//	list-style-type: none;
//	flex-direction: row;
//	gap: 5%;
//	justify-content: center;
//	min-width: auto;
//}
//
//.main-footer-moto {
//	grid-column-start: 5;
//	grid-column-end: 6;
//}

.main-wrapper {
	// height: 90vh;
	display: flex;
	flex-direction: column;
	padding-top: 7em;
}

h1 {
	margin-left: 3rem;
}

a {
	padding: 2rem;
	font-weight: bold;
	font-size: 25px;
	text-decoration: none;
	color: #fcfcfc;
}

nav {
	padding: 15px;

	a {
		font-weight: bold;
		font-size: 1.2em;
		color: #0d0a0b;

		&.router-link-exact-active {
			color: #3f7d20;
		}
	}
}
</style>
