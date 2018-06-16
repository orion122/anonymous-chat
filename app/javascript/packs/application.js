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
            message: '',
            allMessages: []
        },
        methods: {
            enterMessage() {
                this.$http.post(`/chats/${window.location.href.split('/').reverse()[0]}/messages`,
                    {message: this.message},
                    {headers: {'X-Auth-Token': localStorage.getItem('session_token'),
                               'X-CSRF-TOKEN': gon.csrf}
                    }
                ).then(response => {
                    this.message = ''

                }, response => {console.log(localStorage.getItem('session_token'))});
            }
        },
        computed: {
            getMessages() {
                this.$http.get(`/chats/${window.location.href.split('/').reverse()[0]}/messages`,
                               {headers: {'X-Auth-Token': localStorage.getItem('session_token')}}
                               ).then(response => {
                                   this.allMessages = response.body.reduce(((init, messageObject) => {
                                       init.push(`${messageObject.session_id}: ${messageObject.message} (${messageObject.state})`)
                                       return init
                                   }), [])
                }, response => {
                });
            }
        }
    })
})