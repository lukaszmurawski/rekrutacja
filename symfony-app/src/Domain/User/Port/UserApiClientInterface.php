<?php

declare(strict_types=1);

namespace App\Domain\User\Port;

interface UserApiClientInterface
{
    public function list(array $filters = []): array;
    public function get(string $id): ?array;
    public function create(array $data): array;
    public function update(string $id, array $data): array;
    public function delete(string $id): bool;
    public function import(array $data): array;
}
