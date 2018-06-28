<template>
    <div id="welcome">
        <flash-message></flash-message>
        <h1>{{ t_welcome }}</h1>
        <button @click="createChat()">Создать чат</button>
        <button @click="joinRandom()">Присоединиться к чату</button>
        {{ rewriteSessionTokenInLocalStorage() }}
    </div>
</template>

<script>
    export default {
        data() {
            return {
                t_welcome: gon.t_welcome,
                session_token: gon.session_token,
                authenticity_token: gon.csrf
            }
        },
        methods: {
            rewriteSessionTokenInLocalStorage() {
                localStorage.removeItem('session_token')
                localStorage.setItem('session_token', this.session_token)
            },
            createChat() {
                this.$http.post('/chats',
                    {session_token: this.session_token},
                    {headers: { 'X-CSRF-TOKEN': gon.csrf }}
                ).then(response => {
                    this.$router.push(`/chats/${response.body.chat_token}`)
                });
            },
            joinRandom() {
                this.$http.post('/chats/join_random',
                    {session_token: this.session_token},
                    {headers: { 'X-CSRF-TOKEN': gon.csrf }}
                ).then(response => {
                    if (response.body.free_chat_found) {
                        this.$router.push(`/chats/${response.body.chat_token}`)
                    } else {
                        this.flash('Свободный чат не найден', 'warning');
                    }

                });
            }
        }
    }
</script>