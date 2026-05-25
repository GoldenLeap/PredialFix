<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import { FileText, BookOpen } from 'lucide-vue-next';
import type { NavItem } from '@/types';

const footerNavItems: NavItem[] = [
    {
        title: 'Documentação PredialFix',
        href: '#',
        icon: BookOpen,
    },
    {
        title: 'Suporte Técnico',
        href: '#',
        icon: FileText,
    },
];
</script>

<template>
    <SidebarMenu>
        <SidebarMenuItem v-for="item in footerNavItems" :key="item.title">
            <SidebarMenuButton as-child :tooltip="item.title">
                <Link :href="item.href">
                    <component :is="item.icon" />
                    <span class="text-xs">{{ item.title }}</span>
                </Link>
            </SidebarMenuButton>
        </SidebarMenuItem>
    </SidebarMenu>
</template>
