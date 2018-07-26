import Vue from 'vue/dist/vue.esm'
import Welcome from './components/welcome.vue'
import Chat from './components/chat.vue'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import VueFlashMessage from 'vue-flash-message'
import VueI18n from 'vue-i18n'
import VueChatScroll from 'vue-chat-scroll'

Vue.use(VueChatScroll)
Vue.use(VueResource)
Vue.use(VueRouter)
Vue.use(VueFlashMessage)
Vue.use(VueI18n)

var nats = require('websocket-nats').connect('ws://37.60.177.139:4223')
Object.defineProperty(Vue.prototype, '$nats', { value: nats })

const router = new VueRouter({
    mode: 'history',
    routes: [
        { path: '/', component: Welcome },
        { path: '/chats/:token', component: Chat }
    ]
})

const translations = {
    en: {
        root: {
            welcome: "Welcome",
            create_chat: "Create chat",
            join_random_chat: "Join а random chat"
        },
        chat: {
            leave_chat: 'Leave chat'
        },
        flash: {
            no_empty_chats: "Empty chats are missing. Create your own.",
            session_token_exists: "The session with such token exists. Reload page to update the token",
            chat_not_found: 'Chat not found'
        }
    },
    ru: {
        root: {
            welcome: "Добро пожаловать",
            create_chat: "Создать чат",
            join_random_chat: "Присоединиться к случайному чату"
        },
        chat: {
            leave_chat: 'Выйти из чата'
        },
        flash: {
            no_empty_chats: "Пустые чаты отсутствуют. Создай свой.",
            session_token_exists: "Сессия с таким токеном существует. Перезагрузите страницу для обновления токена",
            chat_not_found: 'Чат не найден'
        }
    }
}

const i18n = new VueI18n({
    locale: 'ru',
    messages: translations
})

Vue.http.interceptors.push((request, next) => {
    request.headers.set('X-CSRF-TOKEN', document.querySelector('meta[name="csrf-token"]').getAttribute('content'))
    request.headers.set('X-Auth-Token', localStorage.getItem('session_token'))
    next()
})

const app = new Vue({
    router,
    i18n
}).$mount('#app')
