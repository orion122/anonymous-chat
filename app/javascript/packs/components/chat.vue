<template>
    <div id="chat" class="chat">
        <button @click='logout' class='logout btn btn-secondary'>{{ this.$t('chat.leave_chat') }}</button>
        <ul class="messages" v-chat-scroll>
            <li class="message" v-for="message in messages">{{ message }}</li>
        </ul>
        <input type="text" class='input-box_text' v-model.trim="message" @keyup.enter="saveMessage()" />
    </div>
</template>

<script>
    export default {
        data() {
            return {
                message: '',
                messages: [],
                current_session_token: localStorage.getItem('session_token')
            }
        },
        mounted: function(){
            setInterval(() => {
                if (window.location.pathname == `/chats/${this.getChatToken()}`) {
                    this.getMessages()
                    Rollbar.info("JS: Get all messages after 5 sec")
                }
            }, 5000);
        },
        methods: {
            logout() {
                localStorage.removeItem('session_token')
                window.location.href = '/'
            },
            getMessages() {
                this.$http.get(`/chats/${this.getChatToken()}/messages`
                ).then(response => {
                    let userData = ''
                    this.messages = response.body.reduce(((init, messageObject) => {
                        userData = `${messageObject.nickname}: ${messageObject.message}`
                        if ((messageObject.session_token === this.current_session_token) &&
                            (messageObject.state !== 'delivered')) {
                            userData += ` (${messageObject.state})`
                        }
                        init.push(userData)
                        return init
                    }), [])
                });
                Rollbar.info("JS: Get all messages")
            },
            saveMessage() {
                if(this.message !== '') {
                    this.$http.post(`/chats/${this.getChatToken()}/messages`,
                        {message: this.message}
                    ).then(response => {
                        this.message = ''
                        this.getMessages()
                    });
                    Rollbar.info("JS: Save message")
                }
            },
            setStateRead() {
                this.$http.post(`/chats/${this.getChatToken()}/messages/set_state_read`,
                    {message: this.message}
                );
            },
            getChatToken() {
                return window.location.href.split('/').reverse()[0]
            }
        },
        watch: {
            messages: function () {
                this.setStateRead()
            }
        }
    }
</script>
