import Vue from 'vue/dist/vue.esm'
import VueResource from 'vue-resource';
Vue.use(VueResource);

document.addEventListener('DOMContentLoaded', () => {
    var welcome = new Vue({
        el: '#welcome',
        methods: {
            rewriteSessionTokenInLocalStorage() {
                localStorage.removeItem('session_token')
                localStorage.setItem('session_token', gon.session_token)
                console.log(gon.session_token)
            }
        }
    })

    var chat = new Vue({
        el: '#chat',
        data: {
            messages: []
        },
        methods: {
            showMessages() {
                // this.getMessages()
                console.log(this.messages)
            },
            getMessages() {
                this.$http.get(`/chats/${this.getChatToken(window.location.href)}/messages`,
                               {headers: {'X-Auth-Token': localStorage.getItem('session_token')}}
                               ).then(response => {
                    this.messages = response.body
                }, response => {
                });
            },
            getChatToken(url) {
                return url.split('/').reverse()[0]
            }
        }
    })
})