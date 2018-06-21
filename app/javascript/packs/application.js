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
            }
        }
    })

    var chat = new Vue({
        el: '#chat',
        data: {
            message: '',
            messages: []
        },
        mounted: function(){
            setInterval(() => {
                if (window.location.pathname == `/chats/${this.getChatToken()}`) {
                    this.getMessages()
                }
            }, 5000);
        },
        methods: {
            getMessages() {
                this.$http.get(`/chats/${this.getChatToken()}/messages`,
                    {headers: {
                        'X-Auth-Token': localStorage.getItem('session_token')
                    }}
                ).then(response => {
                    this.messages = response.body.reduce(((init, messageObject) => {
                        init.push(`${messageObject.session_id}: ${messageObject.message} (${messageObject.state})`)
                        return init
                    }), [])
                });
            },
            saveMessage() {
                this.$http.post(`/chats/${this.getChatToken()}/messages`,
                    {message: this.message},
                    {headers: {
                        'X-Auth-Token': localStorage.getItem('session_token'),
                        'X-CSRF-TOKEN': gon.csrf
                    }}
                ).then(response => {
                    this.message = ''
                });
            },
            setStateRead() {
                this.$http.post(`/chats/${this.getChatToken()}/messages/set_state_read`,
                    {message: this.message},
                    {headers: {
                        'X-Auth-Token': localStorage.getItem('session_token'),
                        'X-CSRF-TOKEN': gon.csrf
                    }}
                );
            },
            getChatToken() {
                return window.location.href.split('/').reverse()[0]
            }
        },
        watch: {
            message: function () {
                this.getMessages()
            },
            messages: function () {
                this.setStateRead()
            }
        }
    })
})