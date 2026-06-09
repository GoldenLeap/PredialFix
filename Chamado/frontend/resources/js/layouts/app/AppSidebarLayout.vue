<script setup lang="ts">
import AppContent from '@/components/AppContent.vue';
import AppShell from '@/components/AppShell.vue';
import AppSidebar from '@/components/AppSidebar.vue';
import AppSidebarHeader from '@/components/AppSidebarHeader.vue';
import type { BreadcrumbItem } from '@/types';

type Props = {
    breadcrumbs?: BreadcrumbItem[];
};

withDefaults(defineProps<Props>(), {
    breadcrumbs: () => [],
});
</script>

<template>
    <AppShell variant="sidebar" class="bg-gradient-to-br from-background via-background to-muted/30">
        <AppSidebar />
        <AppContent variant="sidebar" class="overflow-x-hidden pt-4 pr-4 pb-4">
            <div class="bg-card/40 backdrop-blur-3xl rounded-3xl border border-white/10 shadow-lg min-h-full h-full p-6 transition-all duration-300">
                <AppSidebarHeader :breadcrumbs="breadcrumbs" class="mb-6 -mx-2" />
                <slot />
            </div>
        </AppContent>
    </AppShell>
</template>
