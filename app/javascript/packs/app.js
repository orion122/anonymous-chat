import Vue from 'vue/dist/vue.esm'
import Welcome from './components/welcome.vue'
import Chat from './components/chat.vue'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import VueFlashMessage from 'vue-flash-message';

Vue.use(VueResource)
Vue.use(VueRouter)
Vue.use(VueFlashMessage);

const router = new VueRouter({
    mode: 'history',
    routes: [
        { path: '/', component: Welcome },
        { path: '/chats/:token', component: Chat }
    ]
})

const app = new Vue({
    router
}).$mount('#app')